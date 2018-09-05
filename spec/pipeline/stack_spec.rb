
RSpec.describe 'Cloudspin::Stack::Definition' do

  before(:all) do

    stack_definition = Cloudspin::Stack::Definition.from_file(terraform_source_folder + '/stack-definition.yaml')

    instance = Cloudspin::Stack::Instance.new(
      stack_name: 'spec',
      github_owner: 'cloudspin',
      github_repo: 'foo',
      github_branch: 'main',
      github_oath_token: 'xx',
      repo_bucket_name: 'spec_bucket'
    )
    instance.add_config_from_yaml('spin-local.yaml')
    # instance.add_parameter_values(
    #   {
    #     :deployment_identifier => @deployment_identifier,
    #   }
    # )

    @stack_instance = instance
    @stack_instance.up
  end

  after(:all) do
    @stack_instance.down
  end

end
