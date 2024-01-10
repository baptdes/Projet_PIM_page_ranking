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
    
    type T_Matrice is array(1..Capacite,1..Capacite) of float;
    type T_mat is
        record
            nombre_ligne: Integer;
            nombre_colonne: Integer;
            Mat: T_Matrice;
        end record;
    
    type T_Tab is array(1..Capacite) of float;
    type T_vecteur is
        record  
            longueur : Integer;
            tab : T_Tab;
        end record;
    
    --Initialiser une matrice de taille l * c remplie de x
    --On léve l'eception Taille_Hors_Capacite si la taille demandée dépasse les capacités
    procedure Initialiser_matrice(l:in Integer; c:in Integer; x:in float; M:out T_mat);

    -- Initialise un vecteur à la taille l
    procedure Initialiser_vecteur(l : in Integer; x:in float; V : out T_vecteur);

    function nb_lignes(M : T_Mat) return Integer;

    function nb_colones(M : T_Mat) return Integer;

    --Est-ce que la ligne "ligne" dans la matrice M est vide ?
    --Renvoie l'exception Ligne_Hors_Bornes si ligne>nombre_ligne
    function Ligne_Vide (M :in T_mat; l:in Integer) return Boolean;
    
    --Enregistrer valeur à la case (ligne,colonne) dans la matrice M
    --Renvoie l'Excepetion Case_Hors_Bornes si ligne > M.nombre_ligne ou si colonne > M.nombre_colonne
    procedure Enregistrer(M:in out T_mat; ligne:in Integer; colonne:in Integer; valeur:in float);
    
    --Modifier toute une ligne d'une matrice M
    --Renvoie l'exception Ligne_Hors_Bornes si ligne > M.nombre_ligne    
    procedure Modifier_ligne(M:in out T_mat; ligne:in Integer; valeur:in float);
    
    --Addition de deux matrices.
    --Renvoie l'exception Taille_Differente_Addition si les tailles ne correspondent pas
    function "+" (M1, M2: in T_mat) return T_mat;

    --Addition de deux vecteurs.
    --Renvoie l'exception Taille_Differente_Addition si les tailles ne correspondent pas
    function "+" (V1, V2: in T_vecteur) return T_vecteur;

    --Multiplication de deux matrices (attention, on fait M1*M2 et non M2*M1)
    --Renvoie l'exception Taille_Incompatible_Multiplication si les dimenssions ne permettent pas la multiplication
    function "*" (M1, M2 : in T_mat) return T_mat;
    
    --Multiplication d'un vecteur par une matrice (le vecteur M1 est mis en colone pour être multiplier comme une matrice par M)
    --Renvoie l'exception Taille_Incompatible_Multiplication si les dimenssions ne permettent pas la multiplication
    function "*" (V : in T_vecteur; M : in T_mat) return T_vecteur;
    
    --Renvoyer la transposé d'une matrice
    function Transpose(M:in T_mat) return T_mat;
            --Post => Transpose'Result.nombre_ligne = M.nombre_colonne
            --and Transpose'Result.nombre_colonne = M.nombre_ligne
    
    --Renvoie le module d'une matrice colonne
    function norme (V : T_vecteur) return float;
    
    --Multiplication d'une matrice par un scalaire
    function "*" (lambda:in float ; M:in T_mat) return T_mat;

    --Multiplication d'un vecteur par un scalaire
    function "*" (lambda:in float ; V:in T_vecteur) return T_vecteur;

    procedure Quicksort(V: in out T_vecteur; bas, haut: Integer; Indices_tries : out T_vecteur);

    procedure Afficher (M : in T_mat);

    procedure Afficher (V : in T_vecteur);

    function Ligne_max(V:in T_vecteur) return integer;
    
end Matrice;