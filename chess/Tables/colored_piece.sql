CREATE TABLE [chess].[colored_piece] (
    [piece_id]      VARCHAR (6)  NULL,
    [color_id]      VARCHAR (5)  NULL,
    [name]          AS           (concat([color_id],' ',[piece_id])),
    [render_symbol] NCHAR (1)    NOT NULL,
    [fen_symbol]    CHAR (1)     NOT NULL,
    [id]            VARCHAR (12) NOT NULL,
    CONSTRAINT [PK_colored_piece] PRIMARY KEY CLUSTERED ([id] ASC),
    CONSTRAINT [FK__colored_p__color__440B1D61] FOREIGN KEY ([color_id]) REFERENCES [chess].[color] ([id]),
    CONSTRAINT [FK__colored_p__piece__4316F928] FOREIGN KEY ([piece_id]) REFERENCES [chess].[piece] ([id]) ON UPDATE CASCADE
);

