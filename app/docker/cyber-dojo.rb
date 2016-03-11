
# TODO: convert this all to Ruby
# TODO: check with works from any dir (downloads docker-compose.yml)
# TODO: add command to backup katas-data-container to .tgz file
# TODO: create katas-DATA-CONTAINER only if RUNNER=DockerTarPipeRunner?
# TODO: pull ALL language images == fetch? all? pull=all?

$me = 'cyber-dojo.rb'
$my_dir = File.expand_path(File.dirname(__FILE__))

$docker_hub_username='cyberdojofoundation'

#$home = '/usr/src/cyber-dojo'  # home folder *inside* the server image

#RUNNER_DEFAULT=DockerTarPipeRunner
#RUNNER=${RUNNER_DEFAULT}         # see app/models/dojo.rb

#KATAS_DEFAULT=/var/www/cyber-dojo/katas
#KATAS=${KATAS_DEFAULT}           # where katas are stored on the *host*

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def help
  [
    '',
    "Use: #{$me} COMMAND",
    "     #{$me} help",
    '',
    'COMMAND(server):',
    # TODO: backup a katas-ID data-container
    '     down                 Stops and removes server',
    '     up                   Creates and starts the server',
    '',
    'COMMAND(languages):',
    '     images               Lists pulled languages',
    '     pull IMAGE           Pulls language IMAGE',
    '     catalog              Lists all languages',
    '     rmi IMAGE            Removes a pulled language IMAGE',
    '     upgrade              Pulls the latest server and languages',
    ''
  ].each { |line| puts line }
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def up
  puts 'TODO:one_time_create_katas_data_container'
  puts 'TODO:pull_common_languages_if_none'
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def catalog
  `#{$my_dir}/../languages/list_all_images.rb`
  # LANGUAGE          TESTS                IMAGE
  # Asm               assert               nasm_assert
  # BCPL              all_tests_passed     bcpl-all_tests_passed
  # Bash              shunit2              bash_shunit2
  # C (clang)         assert               clang_assert
  # C (gcc)           CppUTest             gcc_cpputest
  # ...
end

def in_catalog?(image)
  catalog.split("\n").drop(0).map{ |line| line.split[2] }.include?(image)
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def pulled_images
  di = `docker images | grep #{$docker_hub_username}`
  # cyberdojofoundation/visual-basic_nunit   latest  eb5f54114fe6 4 months ago 497.4 MB
  # cyberdojofoundation/ruby_mini_test       latest  c7d7733d5f54 4 months ago 793.4 MB
  # cyberdojofoundation/ruby_rspec           latest  ce9425d1690d 4 months ago 411.2 MB
  # ...
  di.split("\n").map{ |line| line.split[0].split('/')[1] }
  # visual-basic_nunit
  # ruby_mini_test
  # ruby_rspec
  # ...
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def images
  pulled = pulled_images
  all = catalog.split("\n")
  puts all.shift # heading
  all.each do |line|
    image = line.split[2]
    puts line if pulled.include? image
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

$docker_compose_file = 'docker-compose.yml'
$docker_compose_cmd = "docker-compose --file=#{$my_dir}/#{$docker_compose_file}"

def services
  `#{$docker_compose_cmd} config --services 2> /dev/null`.split
end

def upgrade
  services.each do |image|
    cmd = "docker pull #{$docker_hub_username}/#{image}"
    `#{cmd}`
  end
  pulled_images.each do |image|
    cmd = "docker pull #{$docker_hub_username}/#{image}"
    `#{cmd}`
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def bad_image(image)
  if image.nil?
    puts 'missing IMAGE'
  else
    puts "unknown IMAGE #{image}"
  end
  puts "Try '#{$me} help'"
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def pull(image)
  if in_catalog?(image)
    `docker pull #{$docker_hub_username}/#{image}:latest`
  else
    bad_image(image)
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def rmi(image)
  if in_catalog?(image)
    `docker rmi #{$docker_hub_username}/#{image}`
  else
    bad_image(image)
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if ARGV.length == 0
  puts 'no command entered'
  puts "Try '#{$me} help'"
  exit
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

options = {}
arg = ARGV[0].to_sym
case arg
when :help, :down, :up, :images, :catalog, :upgrade, :pull, :rmi
  options[arg] = true
else
  puts "#{$me}: #{arg} ?"
  puts "Try '#{$me} help"
  exit
end

help if options[:help]
up if options[:up]
puts catalog if options[:catalog]
images if options[:images]
upgrade if options[:upgrade]
pull(ARGV[1]) if options[:pull]
rmi(ARGV[1]) if options[:rmi]



=begin

    # - - - - - - - up options - - - - - - - -
    katas=*)
      KATAS="${ARG#*=}"
      ;;
    runner=*)
      RUNNER="${ARG#*=}"
      ;;

#========================================================================================
# katas data-container is decoupled from cyber-dojo script
#========================================================================================

KATAS_DATA_CONTAINER=cdf-katas-DATA-CONTAINER

def create_empty_katas_data_container
  #
  # docker build \
  #     --build-arg=CYBER_DOJO_KATAS_ROOT=${HOME}/katas \
  #     --tag=${DOCKER_HUB_USERNAME}/katas \
  #     --file=./app/docker/Dockerfile.katas-data-container.empty \
  #     ${KATAS}
  #
  # rm ${KATAS}/Dockerfile
  #
  # docker run \
  #     --name ${KATAS_DATA_CONTAINER} \
  #     ${DOCKER_HUB_USERNAME}/katas \
  #     echo 'cdfKatasDC'
end

# - - - - - - - - - - - - - - - - - - - - - - - - -

def create_full_katas_data_container
  #
  # docker build \
  #     --build-arg=CYBER_DOJO_KATAS_ROOT=${HOME}/katas \
  #     --tag=${DOCKER_HUB_USERNAME}/katas \
  #     --file=./app/docker/Dockerfile.katas-data-container.copied \
  #     ${KATAS}
  #
  # rm ${KATAS}/Dockerfile
  #
  # docker run \
  #     --name ${KATAS_DATA_CONTAINER} \
  #     ${DOCKER_HUB_USERNAME}/katas \
  #     echo 'cdfKatasDC'
end

# - - - - - - - - - - - - - - - - - - - - - - - - -

def one_time_create_katas_data_container
  if [ ! -d "${KATAS}" ]; then
    if [ "${KATAS}" != "${KATAS_DEFAULT}" ]; then
      echo "${ME}: katas=${KATAS} ? ${KATAS} directory does not exist"
      echo "See ${ME} help"
      exit
    else # no dir at default location. Assume new server
       create_empty_katas_data_container
    fi
  else # katas dir exists, copy into data-container
     create_full_katas_data_container
  fi
end

docker ps -a | grep ${katas_DATA_CONTAINER} > /dev/null
if [ $? != 0 ]; then
  one_time_create_katas_data_container
fi

#========================================================================================
# languages
#========================================================================================

def pull_common_languages_if_none
  CATALOG=$(catalog)
  PULLED=$(pulled_language_images)
  if [ -z "${PULLED}" ]; then
    echo 'No language images pulled'
    echo 'Pulling a small starting collection of common language images'
    IMAGE=gcc_assert
    pull
    #IMAGE=ruby_mini_test
    #pull
  fi
end

=end