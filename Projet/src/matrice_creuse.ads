with TH;
with Ada.Numerics.Elementary_Functions; use  Ada.Numerics.Elementary_Functions;

generic
    Capacite: Integer; -- Capacité max de la matrice
    Taille: Integer; --Nombre de cases dans le tableau de hachage
package Matrice_creuse is
    
    Case_Hors_Bornes : exception;
    Ligne_Hors_Bornes : exception;
    Taille_Differente_Addition: exception;
    Taille_Incompatible_Multiplication: exception;
    Maximum_Indeterminable: exception;
    Module_Indeterminable: exception;
    
    function Fonction_hachage(taille: in Integer; Cle1: in Integer; Cle2: in Integer) return Integer;
        
    package Hachage is 
        new TH(Capacite => Taille, T_Cle => Integer, T_Valeur => Float, fonction_hachage => Fonction_hachage);
    use Hachage;

    type T_Mat is private;

    type T_Tab is array(1..Capacite) of float;
    type T_vecteur is
        record  
            longueur : Integer;
            tab : T_Tab;
        end record;

    --Renvoie le nombre de lignes
    function nb_lignes(M : T_Mat) return Integer;

    --Renvoie le nombre de colones
    function nb_colones(M : T_Mat) return Integer;

    -- Initialise un vecteur à la taille l
    procedure Initialiser_vecteur(l : in Integer; x:in float; V : out T_vecteur);
    
    --Initialiser une matrice de taille l * c creuse (aucune valeur présente au début)
    --On léve l'exception Taille_Hors_Capacite si la taille demandé dépasse les capacités
    procedure Initialiser_matrice(l:in Integer; c:in Integer; M:out T_mat);

    -- Récupère la valeur d'une case (i,j) et renvoie 0 si la case n'existe pas
    -- Exception levé si i et j hors bornes
    function Valeur(M : in T_mat; i : in Integer; j : in Integer) return Float;

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

    --Multiplication de deux matrices (attention, on fait M1*M2 et non M2*M1)
    --Renvoie l'exception Taille_Incompatible_Multiplication si les dimenssions ne permettent pas la multiplication
    function "*" (M1, M2 : in T_mat) return T_mat;

    --Multiplication d'un vecteur par une matrice (le vecteur M1 est mis en colone pour être multiplier comme une matrice par M)
    --Renvoie l'exception Taille_Incompatible_Multiplication si les dimenssions ne permettent pas la multiplication
    function "*" (V : in T_vecteur; M : in T_mat) return T_vecteur;

        --Renvoie la distance entre deux vecteurs d'une matrice colonne
    function distance (V1 : in T_vecteur;V2 : in T_vecteur) return float;
    
    --Multiplication d'une matrice par un scalaire
    function "*" (lambda:in float ; M:in T_mat) return T_mat;

    --Multiplication d'un vecteur par un scalaire
    function "*" (lambda:in float ; V:in T_vecteur) return T_vecteur;

        --Addition de deux vecteurs.
    --Renvoie l'exception Taille_Differente_Addition si les tailles ne correspondent pas
    function "+" (V1, V2: in T_vecteur) return T_vecteur;

    -- Renvoie le max d'un vecteur
    function max(V:in T_vecteur) return integer;

    -- Somme les termes d'un vecteur
    function somme(V:in T_vecteur) return Float;

    --Somme d'un vecteur avec un réel
    function "+"(V:in T_vecteur;x : in Float) return T_vecteur;

    procedure Afficher (V : in T_vecteur);

    -- Détruire une matrice
    procedure Detruire_mat (M :  in out T_Mat);

    generic
		with procedure Traiter_element (Couple : T_Couple; Valeur: in Float);
	procedure Pour_Chaque (M : in T_Mat);

private
    type T_mat is
        record
            nombre_ligne: Integer;
            nombre_colonne: Integer;
            Mat: T_TH;
        end record;
end Matrice_creuse;
