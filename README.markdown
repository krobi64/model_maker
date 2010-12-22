# model_maker

Runs under Rails 3.0

This is the very beginning of a project I'm working on to scrub a legacy database and create ActiveRecord model files from the results. For the first steps, I'm limiting this project to:

1. Only MySql
2. Start creating shell files then add:
     a. has_many and belongs_to relationships
     b. many_to_many relationships will assume a belong_to_and_has_many relationship at first

To be added later:

1. Read from YML file belongs_to_and_has_many vs. has_many :through overrides
2. Introspect on a pattern to determine which many_to_many configuration to use.


