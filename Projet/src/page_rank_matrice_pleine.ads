with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package page_rank_matrice_pleine is
    procedure page_rank (nombre_site : in Integer; alpha : in Float; k : in Integer ; epsilon : in Float ; Prefix : in Unbounded_String; nom_fichier_net : in Unbounded_String);
end page_rank_matrice_pleine;