with LCA;
with ada.Numerics.Elementary_Functions; use ada.Numerics.Elementary_Functions;

generic
    Capacite: Integer;
package Matrice is
    
    Taille_Hors_Capacite : exception;
    Case_Hors_Bornes : exception;
    Ligne_Hors_Bornes : exception;
    Taille_Differente_Addition: exception;
    Taille_Incompatible_Multiplication: exception;
    Maximum_Indeterminable: exception;
    Module_Indeterminable: exception;
    
    
    type T_mat is limited private;
    
    --Initialiser une matrice de taille l * c remplie de x
    --On léve l'eception Taille_Hors_Capacite si la taille demandée dépasse les capacités
    procedure Initialiser(l:in Integer; c:in Integer; x:in Float; M:out T_mat);
    
    --Obtenir le nombre de ligne de la matrice M
    function Nombre_ligne(M:T_mat) return Integer;
    
    --Obtenir le nombre de colonne de la matrice M
    function Nombre_colonne(M:T_mat) return Integer;
    
    --Est-ce que la ligne "ligne" dans la matrice M est vide ?
    --Renvoie l'exception Ligne_Hors_Bornes si ligne>nombre_ligne
    function Ligne_Vide (M :in T_mat; l:in Integer) return Boolean;
    
    --Enregistrer valeur à la case (ligne,colonne) dans la matrice M
    --Renvoie l'Excepetion Case_Hors_Bornes si ligne > M.nombre_ligne ou si colonne > M.nombre_colonne
    procedure Enregistrer(M:in out T_mat; ligne:in Integer; colonne:in Integer; valeur:in float);
    
    --Modifier toute une ligne d'une matrice M
    --Renvoie l'exception Ligne_Hors_Bornes si ligne > M.nombre_ligne    
    procedure Modifier_ligne(M:in out T_mat; ligne:in Integer; valeur:in float);
    
    --Renvoyer la ligne qui contient le maximum d'une /!\ MATRICE COLONNE /!\
    --Renvoie l'exception Maximum_Indeterminable si la matrice n'est pas une matrice colonne
    function Ligne_max(M:in T_mat) return integer;
    
    --Addition de deux matrices.
    --Renvoie l'exception Taille_Differente_Addition si les tailles ne correspondent pas
    function Addition(M1:in T_mat; M2:in T_mat) return T_mat;
    
    --Multiplication de deux matrices (attention, on fait M1*M2 et non M2*M1)
    --Renvoie l'exception Taille_Incompatible_Multiplication si les dimenssions ne permettent pas la multiplication
    function Multiplication(M1:in T_mat; M2:in T_mat) return T_mat;
    
    
    --Renvoyer la transposé d'une matrice
    function Transpose(M:in T_mat) return T_mat;
            --Post => Transpose'Result.nombre_ligne = M.nombre_colonne
            --and Transpose'Result.nombre_colonne = M.nombre_ligne
    
    --Renvoie le module d'une matrice colonne
    function norme (M:in T_mat) return Float;
        --Pre => M.nombre_colonne = 1
    
    --Multiplication par un scalaire
    function multiplier_scalaire (M:in T_mat;lambda:in Float) return T_mat;
            
private
    type T_Matrice is array(1..Capacite,1..Capacite) of float;
    type T_mat is
        record
            nombre_ligne: Integer;
            nombre_colonne: Integer;
            Mat: T_Matrice;
        end record;
    
end Matrice;
