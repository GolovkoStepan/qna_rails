bp:
	bundle exec rubocop -a
	bundle exec rspec spec
	brakeman
