#!/usr/bin/env ruby

require_relative '../../admin_scripts/lib_domain'
require 'digest/sha1'

def excluded?(filename)
  %w{ output instructions makefile cyber-dojo.sh }.include?(filename)
end

def content_hash(visible_files)
  hash = 0
  visible_files.each do |filename,content|
    if !excluded?(filename)
      hash ^= Digest::SHA1.hexdigest(content).hex
    end
  end
  hash.to_s(16)
end

dojo = create_dojo

namespace :db do
    desc "Fill database with DojoStartPoint/AvatarSession data"
    task :populate => :environment do

    dojo.katas.each do |kata|
      dsp = DojoStartPoint.create!(
        :dojo_id => kata.id,
        :language => kata.language.name,
        :exercise => kata.exercise.name
      )
      p "DOJO=#{kata.id}"
      kata.avatars.active.each do |avatar|
        as = AvatarSession.create!(
          :dojo_start_point => dsp,
          :avatar => avatar.name,
          :vote_count => 0
        )
        t0 = avatar.tags[0]
        ch = content_hash(t0.visible_files)
        p "  AVATAR=#{avatar.name} TAG0=#{ch}"
        TrafficLight.create!(
          :avatar_session => as,
          :tag => 0,
          :colour => 'white',
          :content_hash => ch,
          :fork_count => 0
        )

        avatar.lights.each do |light|
          TrafficLight.create!(
            :avatar_session => as,
            :tag => light.tag.number,
            :colour => light.colour,
            :content_hash => content_hash(light.tag.visible_files),
            :fork_count => 0
          )
        end
      end
    end

    p "-----------------------------------------"

    DojoStartPoint.all.each do |start_point|
      sessions = start_point.avatar_sessions.all
      if sessions != []
        tag0 = sessions[0].traffic_lights.find_by tag: 0
        p "DOJO=#{start_point.dojo_id} TAG0=#{tag0.content_hash}"
      end
    end

    p "-----------------------------------------"

    # now populate the fork_counts
    DojoStartPoint.all.each do |start_point|
      p start_point.dojo_id
      sessions = start_point.avatar_sessions.all
      if sessions != []
        session = sessions[0]
        tag0 = session.traffic_lights.find_by tag: 0

        # matching in the *same* avatar_session
        # corresponds to a revert, or timeout-sequence, or [test] repeat
        my_lights = TrafficLight.where(
          "avatar_session_id == ? AND content_hash == ? AND tag != ?",
          session.id, tag0.content_hash, 0).
        find_all.entries

        my_lights.each do |light|
          # need to ignore tag1 since it cannot be a revert
          # can't revert when you had nothing to revert from!
          p "  MINE: #{light.inspect}"
        end

        # matching in a *different* avatar_session
        # corresponds to a fork
        other_lights = TrafficLight.where(
          "avatar_session_id != ? AND content_hash == ? AND tag != ?",
          session.id, tag0.content_hash, 0).
        find_all.entries

        other_lights.each do |light|
          # will be several if [test] repeats occured
          # take the first one and assume it was a fork
          p "  OTHER: #{light.inspect}"
        end
        if other_lights != []
          light = other_lights[0]
          p "  INC: #{light.inspect}"
          light.increment!(:fork_count)
          p "  INC: #{light.inspect}"
        end

      end
    end

  end
end



#p tag0_hash(dojo.katas['898E24E7ED'].avatars['elephant'].lights[21].tag.visible_files)
