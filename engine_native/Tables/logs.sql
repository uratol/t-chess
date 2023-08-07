CREATE TABLE [engine_native].[logs] (
    [id]   INT            IDENTITY (1, 1) NOT NULL,
    [data] NVARCHAR (MAX) NULL,
    PRIMARY KEY NONCLUSTERED ([id] ASC)
)
WITH (MEMORY_OPTIMIZED = ON);

