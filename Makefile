check:
	bundle exec rubocop -A
	bundle exec rspec spec
	brakeman
