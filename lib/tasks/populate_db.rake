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

      kata.avatars.active.each do |avatar|
        as = AvatarSession.create!(
          :dojo_start_point => dsp,
          :avatar => avatar.name,
          :vote_count => 0
        )

        t0 = avatar.tags[0]
        TrafficLight.create!(
          :avatar_session => as,
          :tag => 0,
          :colour => 'white',
          :content_hash => content_hash(t0.visible_files),
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

    # now populate the fork_count of each traffic_light
    DojoStartPoint.all.each do |start_point|
      p start_point.dojo_id
      start_point.avatar_sessions.each do |session|
        session.traffic_lights.each do |light|
          #p "#{start_point.dojo_id} #{session.avatar} #{light.tag} #{light.colour}"
          p light.content_hash
        end
      end
    end

  end
end



#p tag0_hash(dojo.katas['898E24E7ED'].avatars['elephant'].lights[21].tag.visible_files)
