require 'serverspec'
require 'docker'

describe 'image' do
	before(:all) do
		puts 'Running ubuntu image tests from:'
		puts File.expand_path(File.dirname(__FILE__))

		image = Docker::Image.import(ENV.fetch('TEMPLATE_IMAGE'))

		set :os, family: :ubuntu
		set :backend, :docker
		set :docker_image, image.id
	end

	it 'installs the right version of Ubuntu' do
		expect(os_version).to include('Ubuntu 14')
	end

	def os_version
		command('lsb_release -a').stdout
	end
end
