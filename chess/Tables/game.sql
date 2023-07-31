CREATE TABLE [chess].[game] (
    [id]           UNIQUEIDENTIFIER DEFAULT (newid()) NOT NULL,
    [state]        VARCHAR (30)     NULL,
    [board_id]     UNIQUEIDENTIFIER NULL,
    [ordinal]      INT              IDENTITY (1, 1) NOT NULL,
    [white_player] VARCHAR (10)     NOT NULL,
    [black_player] VARCHAR (10)     NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC),
    CHECK ([black_player]='Player' OR [black_player]='AI'),
    CHECK ([state]='Stalemate' OR [state]='Black wins' OR [state]='White wins' OR [state]='White to move' OR [state]='Black to move'),
    CHECK ([white_player]='Player' OR [white_player]='AI'),
    FOREIGN KEY ([board_id]) REFERENCES [chess].[board] ([id])
);




GO
CREATE NONCLUSTERED INDEX [ix_game_ordinal]
    ON [chess].[game]([ordinal] ASC);


GO
create trigger [chess].tr_game_delete
   on  chess.game
   after delete
as 

delete b
from chess.board as b
	join DELETED as d on d.board_id = b.id