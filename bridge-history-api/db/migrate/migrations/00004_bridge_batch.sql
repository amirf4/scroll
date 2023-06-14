-- +goose Up
-- +goose StatementBegin
create table bridge_batch
(
    id                  BIGSERIAL PRIMARY KEY,
    height              BIGINT NOT NULL,
    start_block_number  BIGINT NOT NULL,
    end_block_number    BIGINT NOT NULL,
    is_deleted          BOOLEAN NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at          TIMESTAMP(0) DEFAULT NULL
);

comment 
on column bridge_batch.is_deleted is 'NotDeleted, Deleted';

CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_timestamp BEFORE UPDATE
ON bridge_batch FOR EACH ROW EXECUTE PROCEDURE
update_timestamp();

CREATE OR REPLACE FUNCTION delete_at_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_deleted AND OLD.is_deleted != NEW.is_deleted THEN
        UPDATE bridge_batch SET delete_at = NOW() WHERE id = NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_at_trigger
AFTER UPDATE ON bridge_batch
FOR EACH ROW
EXECUTE FUNCTION delete_at_trigger();


-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
drop table if exists bridge_batch;
-- +goose StatementEnd