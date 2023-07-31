CREATE TABLE [chess].[piece] (
    [id]            VARCHAR (6) NOT NULL,
    [name]          AS          (CONVERT([nvarchar],[id])),
    [render_symbol] NCHAR (1)   NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

