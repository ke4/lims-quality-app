.PHONY: migrate_test serve
CORE_PATH = '.'
migrate_test_mysql:
	mysql -uroot -p -e "DROP DATABASE IF EXISTS quality_test; CREATE DATABASE quality_test DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
	bundle exec sequel -m $(CORE_PATH)/db/migrations -e test_mysql config/database.yml
migrate_dev_mysql:
	mysql -uroot -p -e "DROP DATABASE IF EXISTS quality_development; CREATE DATABASE quality_development DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"
	bundle exec sequel -m $(CORE_PATH)/db/migrations -e development_mysql config/database.yml
migrate_test:
	bundle exec sequel -m $(CORE_PATH)/db/migrations -e test config/database.yml
migrate_dev:
	bundle exec sequel -m $(CORE_PATH)/db/migrations -e development config/database.yml
serve:
	rabbitmq-server | bundle exec rackup
dserve:
	bundle exec rackup -d

%: %.erb
	erb < $< > $@

APIARY_SOURCE_DIR= requests/apiary
APIARY_SOURCES= $(shell find $(APIARY_SOURCE_DIR) )
APIARY_JSON_SOURCES= ${patsubst %.erb,%, ${APIARY_SOURCES}}

apiary.apib: script/generate_apiary.rb $(APIARY_SOURCE_DIR) $(APIARY_JSON_SOURCES)
	ruby script/generate_apiary.rb > $@

RSPEC_JSON_DIR = requests
RSPEC_SOURCES = $(shell find $(RSPEC_JSON_DIR) -name '*.json.erb')
RSPEC_JSON_SOURCES = ${patsubst %.erb,%, ${RSPEC_SOURCES}}
generate_specs: script/generate_rspec.rb $(RSPEC_JSON_SOURCES)
	ruby script/generate_rspec.rb

