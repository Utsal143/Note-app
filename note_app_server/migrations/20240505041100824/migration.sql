BEGIN;


--
-- MIGRATION VERSION FOR note_app
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('note_app', '20240505041100824', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240505041100824', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240115074235544', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240115074235544', "timestamp" = now();


COMMIT;
