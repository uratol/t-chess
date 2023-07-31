CREATE TABLE [chess].[move] (
    [id]        UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [half_move] INT              NOT NULL,
    [board_id]  UNIQUEIDENTIFIER NULL,
    [from_col]  TINYINT          NOT NULL,
    [from_row]  TINYINT          NOT NULL,
    [to_col]    TINYINT          NOT NULL,
    [to_row]    TINYINT          NOT NULL,
    PRIMARY KEY NONCLUSTERED ([id] ASC),
    CONSTRAINT [fk_move_board] FOREIGN KEY ([board_id]) REFERENCES [chess].[board] ([id]) ON DELETE CASCADE
);


GO
CREATE CLUSTERED INDEX [ix_move_board_id]
    ON [chess].[move]([board_id] ASC, [half_move] DESC);

