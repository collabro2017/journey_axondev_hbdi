require 'rake/testtask'

namespace :test do
  namespace :nerve do
    Rake::TestTask.new(:unit) do |t|
      t.libs << 'lib/nerve'
      t.libs << 'lib/nerve.rb'
      t.libs << 'test_nerve'
      t.test_files = FileList['test_nerve/unit/*_test.rb'].exclude(/integration/)
    end

    Rake::TestTask.new(:integration) do |t|
      t.libs << 'lib/nerve'
      t.libs << 'lib/nerve.rb'
      t.libs << 'test_nerve'
      t.test_files = FileList['test_nerve/integration/*_test.rb']
    end
  end

  task :nerve => "nerve:unit"

end
