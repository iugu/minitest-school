watch( 'test/.*_test\.rb' )  {|md| system("bundle exec ruby -Ilib -Itest #{md[0]}") }
watch( '^lib/(.*)\.rb' )      {|md| system("bundle exec ruby -Ilib -Itest test/lib/#{md[1]}_test.rb") }
