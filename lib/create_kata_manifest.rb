
module CreateKataManifest # mix-in

  module_function

  def create_kata_manifest(language, exercise, id, now)
    # a kata's id has 10 hex chars. This gives 16^10 possibilities
    # which is 1,099,511,627,776 which is big enough to not
    # need to check that a kata with the id already exists.
    manifest = {
                       id: id,
                  created: now,
                 language: language.name,
                 exercise: exercise.name,
      unit_test_framework: language.unit_test_framework,
                 tab_size: language.tab_size
    }
    manifest[:visible_files] = language.visible_files
    manifest[:visible_files]['output'] = ''
    manifest[:visible_files]['instructions'] = exercise.instructions
    manifest
  end

end
