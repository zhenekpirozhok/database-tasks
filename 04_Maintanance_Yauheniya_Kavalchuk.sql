CREATE OR REPLACE
FUNCTION manage_sales_partition() RETURNS integer
    LANGUAGE plpgsql AS
$$
DECLARE
   regPatternTableName varchar;
   targetTableName varchar;
   oneMonthLater varchar;
   twoMonthLater varchar;
   lastValidTableName varchar;
   _tb_name information_schema.tables.table_name%TYPE;
BEGIN
    SELECT 'sales_\d{4}_\d{2}' INTO regPatternTableName;
    -- Get the next year and month
    SELECT to_char(now() + INTERVAL '1 month', 'sales_YYYY_MM') INTO targetTableName;

    -- Get range begin and end with date of next month
    SELECT to_char(now() + INTERVAL '1 month', 'YYYY-MM-DD') INTO oneMonthLater;
    SELECT to_char(now() + INTERVAL '2 month', 'YYYY-MM-DD') INTO twoMonthLater;
    SELECT to_char(now() - INTERVAL '12 month', 'sales_YYYY_MM') INTO lastValidTableName;

    -- Create the partition for the next month
    EXECUTE format('CREATE TABLE IF NOT EXISTS %I PARTITION OF sales FOR VALUES FROM (%L) TO (%L);', targetTableName, oneMonthLater, twoMonthLater);

    -- Remove partitions that are older than a year
    FOR _tb_name IN
        SELECT table_name
        FROM information_schema.TABLES
        WHERE table_name ~ regPatternTableName
        AND table_name <= lastValidTableName
    LOOP
        EXECUTE format('DROP TABLE IF EXISTS %I', _tb_name);
    END LOOP;
    RETURN 1;
END;
$$;

-- create extension pg_cron
CREATE EXTENSION pg_cron;

-- create a pg_cron task and schedule monthly
SELECT cron.schedule('0 0 1 * *', $$SELECT manage_sales_partition();$$);