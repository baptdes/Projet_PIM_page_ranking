generic
    Capacite: Integer; -- Capacité des vecteurs

    type T_Valeur is private;
    
    with function "+" (Left, Right : T_valeur) return T_valeur is <>;
    with function "-" (Left, Right : T_valeur) return T_valeur is <>;
    with function "*" (Left, Right : T_valeur) return T_valeur is <>;
    with function ">=" (Left, Right : T_valeur) return Boolean is <>;
    with function sqrt (x : T_Valeur) return T_Valeur is <>;
package Vecteurs is
    --Exceptions
    Taille_Differente_Addition : exception;

    type T_Tab is array(1..Capacite) of T_valeur;
    type T_vecteur is
        record  
            longueur : Integer;
            tab : T_Tab;
        end record;

    -- Initialise un vecteur à la taille l
    procedure Initialiser_vecteur(l : in Integer; x:in T_valeur; V : out T_vecteur);

    --Multiplication d'un vecteur par un scalaire
    function "*" (lambda:in T_valeur ; V:in T_vecteur) return T_vecteur;

    --Addition de deux vecteurs.
    --Renvoie l'exception Taille_Differente_Addition si les tailles ne correspondent pas
    function "+" (V1, V2: in T_vecteur) return T_vecteur;

    --Somme d'un vecteur avec un réel
    function "+"(V:in T_vecteur; x : in T_Valeur) return T_vecteur;

    -- Renvoie le max d'un vecteur
    function max(V:in T_vecteur) return integer;

    -- Somme les termes d'un vecteur
    function somme(V:in T_vecteur) return T_valeur;

    --Renvoie la distance entre deux vecteurs d'une matrice colonne
    function distance (V1 : in T_vecteur;V2 : in T_vecteur) return T_valeur;
end Vecteurs;
