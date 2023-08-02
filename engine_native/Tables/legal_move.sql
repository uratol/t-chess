CREATE TABLE [engine_native].[legal_move] (
    [piece_id] UNIQUEIDENTIFIER NOT NULL,
    [col]      TINYINT          NOT NULL,
    [row]      TINYINT          NOT NULL,
    PRIMARY KEY NONCLUSTERED ([piece_id] ASC, [col] ASC, [row] ASC)
)
WITH (DURABILITY = SCHEMA_ONLY, MEMORY_OPTIMIZED = ON);

