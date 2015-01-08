#!/usr/bin/env ruby

require_relative '../../admin_scripts/lib_domain'
require 'digest/sha1'

def excluded?(filename)
  %w{ output instructions makefile cyber-dojo.sh }.include?(filename)
end

def tag0_hash(visible_files)
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
        :exercise => kata.exercise.name,
        :tag0_content_hash => tag0_hash(kata.visible_files)
      )

      kata.avatars.active.each do |avatar|
        AvatarSession.create!(
          :dojo_start_point => dsp,
          :vote_count => 0,
          :fork_count => 0
        )
      end
    end
  end
end

#p tag0_hash(dojo.katas['898E24E7ED'].avatars['elephant'].lights[21].tag.visible_files)
