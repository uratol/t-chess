CREATE TABLE [engine_native].[piece] (
    [id]          UNIQUEIDENTIFIER NOT NULL,
    [board_id]    UNIQUEIDENTIFIER NOT NULL,
    [fen_symbol]  CHAR (1)         NOT NULL,
    [is_white]    BIT              NULL,
    [col]         TINYINT          NOT NULL,
    [row]         TINYINT          NOT NULL,
    [is_captured] BIT              DEFAULT ((0)) NOT NULL,
    [weight]      AS               (case [fen_symbol] when 'p' then (1) when 'n' then (3) when 'b' then (3) when 'r' then (5) when 'q' then (9) when 'k' then (100)  end) PERSISTED NOT NULL,
    PRIMARY KEY NONCLUSTERED ([id] ASC),
    FOREIGN KEY ([board_id]) REFERENCES [engine_native].[board] ([id])
)
WITH (DURABILITY = SCHEMA_ONLY, MEMORY_OPTIMIZED = ON);



