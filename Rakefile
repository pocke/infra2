namespace :itamae do
  desc '[DRY RUN] apply itamae to skitty'
  task :skitty do
    sh 'itamae ssh --dry-run --node-yaml nodes/secrets.yml --host skitty roles/raspberry-pi-4.rb'
  end

  desc 'apply itamae to skitty'
  task :"skitty:apply" do
    sh 'itamae ssh --node-yaml nodes/secrets.yml --host skitty roles/raspberry-pi-4.rb'
  end
end
