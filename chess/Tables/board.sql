CREATE TABLE [chess].[board] (
    [id]             UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [selected_piece] UNIQUEIDENTIFIER NULL,
    [color_to_move]  VARCHAR (5)      NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    FOREIGN KEY ([color_to_move]) REFERENCES [chess].[color] ([id]),
    CONSTRAINT [fk_board_selected_piece] FOREIGN KEY ([selected_piece]) REFERENCES [chess].[board_piece] ([id])
);



