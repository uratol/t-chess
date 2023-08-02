CREATE TABLE [engine_native].[move] (
    [id]                UNIQUEIDENTIFIER NOT NULL,
    [piece_id]          UNIQUEIDENTIFIER NOT NULL,
    [col_from]          TINYINT          NOT NULL,
    [row_from]          TINYINT          NOT NULL,
    [col_to]            TINYINT          NOT NULL,
    [row_to]            TINYINT          NOT NULL,
    [captured_piece_id] UNIQUEIDENTIFIER NULL,
    PRIMARY KEY NONCLUSTERED ([id] ASC)
)
WITH (DURABILITY = SCHEMA_ONLY, MEMORY_OPTIMIZED = ON);

