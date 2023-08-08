CREATE TYPE [engine_native].[moves] AS TABLE (
    [piece_id] UNIQUEIDENTIFIER NOT NULL,
    [col]      TINYINT          NOT NULL,
    [row]      TINYINT          NOT NULL,
    [weight]   REAL             NULL,
    PRIMARY KEY NONCLUSTERED ([col] ASC, [row] ASC, [piece_id] ASC))
    WITH (MEMORY_OPTIMIZED = ON);

