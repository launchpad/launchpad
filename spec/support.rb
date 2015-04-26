Dir.chdir('spec') { Dir['support/**/*.rb'].each { |file| require file } }
