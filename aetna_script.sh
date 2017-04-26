bin/delayed_job stop

rake db:reset && rake db:seed:aetna_demo && rake import:ndc

bin/delayed_job start

rake db:seed:mike_insurance

rake db:seed:mike_meds

# do this right when Kash gets control
rake db:seed:kash_labs
