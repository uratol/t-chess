CREATE TYPE [engine_native].[coordinates] AS TABLE (
    [col] TINYINT NOT NULL,
    [row] TINYINT NOT NULL,
    PRIMARY KEY NONCLUSTERED ([col] ASC, [row] ASC))
    WITH (MEMORY_OPTIMIZED = ON);

