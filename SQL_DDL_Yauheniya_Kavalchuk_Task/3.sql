ALTER TABLE country
ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE area
ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE city
ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE mountain
ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE address
ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE climb
ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE club_event
ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE climber
ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE emergency_contact
ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE climber_climb_m2m
ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;