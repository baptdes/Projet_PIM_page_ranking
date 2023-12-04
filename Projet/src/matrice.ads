with LCA;

generic
    Capacite: Integer;
package matrice is
    
    Case_Hors_Bornes : exception;
    Ligne_Hors_Bornes : exception;
    Taille_Differente_Addition: exception;
    Taille_Incompatible_Multiplication: exception;
    
    
    type T_mat is limited private;
    
    --Initialiser une matrice de taille l * c remplie de x
    procedure Initialiser(l:in Integer; c:in Integer; M:out T_mat);
    
    --Est-ce que la ligne "ligne" dans la matrice M est vide ?
    --Renvoie l'exception Ligne_Hors_Bornes si ligne>nombre_ligne
    function Ligne_Vide (M :in T_mat; l:in Integer) return Boolean;
    
    --Enregistrer valeur à la case (ligne,colonne) dans la matrice M
    --Renvoie l'Excepetion Case_Hors_Bornes si ligne>nombre_ligne ou si colonne>nombre_colonne
    procedure Enregistrer(M:in out T_mat; ligne:in Integer; colonne:in Integer; valeur:in float);
    
    --Addition de deux matrices.
    --Renvoie l'exception Taille_Differente_Addition si les tailles ne correspondent pas
    function Addition(M1:in T_mat; M2:in T_mat) return T_mat;
    
    --Multiplication de deux matrices (attention, on fait M1*M2 et non M2*M1)
    --Renvoie l'exception Taille_Incompatible_Multiplication si les dimenssions ne permettent pas la multiplication
    function Multiplication(M1:in T_mat; M2:in T_mat) return T_mat;
            
private
    type T_Matrice is array(1..Capacite,1..Capacite);
    type T_mat is
        record
            nombre_ligne: Integer;
            nombre_colonne: Integer;
            Mat: T_Matrice;
        end record;
    
end matrice;
