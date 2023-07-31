CREATE TABLE [chess].[color] (
    [id]   VARCHAR (5) NOT NULL,
    [name] AS          (CONVERT([nvarchar],[id])),
    PRIMARY KEY CLUSTERED ([id] ASC)
);

