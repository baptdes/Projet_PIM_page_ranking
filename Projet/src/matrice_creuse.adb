with Ada.Numerics.Elementary_Functions; use  Ada.Numerics.Elementary_Functions;
with Ada.Text_IO;			use Ada.Text_IO;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;

package body Matrice_creuse is

    function Fonction_hachage(taille: in Integer; Cle1: in Integer; Cle2: in Integer) return Integer is
    begin
        return (Cle1 + Cle2) mod taille;
    end Fonction_hachage;
    
    procedure Initialiser_matrice(l:in Integer; c:in Integer; M:out T_mat) is
    begin
        -- On vérifie que l'on se trouve dans les bornes de la matrice
        if l < Capacite and l > 0 and c < Capacite and c > 0 then
            M.nombre_colonne := c;
            M.nombre_ligne := l;
            Hachage.Initialiser(M.Mat);
        else
            raise Taille_Hors_Capacite;
        end if;
    end Initialiser_matrice;

    procedure Initialiser_vecteur(l : in Integer; x:in float; V : out T_vecteur) is
    begin
        for i in 1..l loop
            V.Tab(i) := x;
        end loop;
        V.longueur := l;
    end Initialiser_vecteur;

    function nb_lignes(M : T_Mat) return Integer is
    begin
        return M.nombre_ligne;
    end;

    function nb_colones(M : T_Mat) return Integer is
    begin
        return M.nombre_ligne;
    end;

    function Valeur(M : in T_mat; i : in Integer; j : in Integer) return Float is
        Out_of_bounds : exception;
    begin
        -- Si les indices dépassent les bornes ont lève une exception
        if i > M.nombre_ligne or j > M.nombre_colonne then
            raise Out_of_bounds;
        else
            -- On regarde si la clé est présente et si c'est le cas ont retourne la valeur associé sinon 0.0
            if Hachage.Cle_Presente(M.Mat, i, j) then
                return Hachage.La_Valeur(M.Mat,i,j);
            else
                return 0.0;
            end if;
        end if;
    end Valeur;
        
    --Est-ce que la ligne "ligne" dans la matrice M est vide ?
    --Renvoie l'exception Ligne_Hors_Bornes si ligne>nombre_ligne
    function Ligne_Vide (M :in T_mat; l:in Integer) return Boolean is
    begin
        if M.nombre_ligne >= l then
            for i in 1..M.nombre_colonne loop
                --On vérifie si le couple ligne l colone i existe dans le tableau où non
                if Hachage.Cle_Presente(M.Mat, l, i) then
                    return False;
                end if;
            end loop;
            -- Si le programme ne trouve aucune valeur pour la ligne, alors c'est que c'est bien vide.
            return True;
        else
            -- on léve l'exception si l > M.nombre_ligne
            raise Ligne_Hors_Bornes;
        end if;
    end Ligne_Vide;
    
    --Enregistrer valeur à la case (ligne,colonne) dans la matrice M
    --Renvoie l'Excepetion Case_Hors_Bornes si ligne > M.nombre_ligne ou si colonne > M.nombre_colonne
    procedure Enregistrer(M:in out T_mat; ligne:in Integer; colonne:in Integer; valeur:in float) is
    begin
        -- Dans le cas d'une matrice creuse, si la valeur est 0, c'est que l'on veut supprimer la clé du tableau
        -- de hachage
        if abs(valeur - 0.0) < 0.00001  then
            -- est-ce que la valeur était différente de 0 avant ? Ce qui revient à demander si la clé est présente dans
            -- notre tableau de hachage ou non
            if Hachage.Cle_Presente(M.Mat, ligne, colonne) then
                -- on supprime la clé (ligne,colonne) du tableau ce qui revient à un mise à 0
                Hachage.Supprimer(M.Mat,ligne,colonne);
            else
                -- Si la valeur était déjà à 0, on ne fais rien
                null;
            end if;
        -- si la valeur n'est pas de 0, on modifie quoi qu'il arrive le tableau de hachage
        else
            Hachage.Enregistrer(M.Mat,ligne,colonne,valeur);
        end if;
    end Enregistrer;
    
    
    --Modifier toute une ligne d'une matrice M
    --Renvoie l'exception Ligne_Hors_Bornes si ligne > M.nombre_ligne    
    procedure Modifier_ligne(M:in out T_mat; ligne:in Integer; valeur:in float) is
    begin
        if ligne <= M.nombre_ligne then
            for i in 1..M.nombre_colonne loop
                Enregistrer(M.Mat, ligne, i, valeur);
            end loop;
        else
            raise Ligne_Hors_Bornes;
        end if;
    end Modifier_ligne;
    
    --Addition de deux matrices.
    --Renvoie l'exception Taille_Differente_Addition si les tailles ne correspondent pas
    function "+" (M1, M2: in T_mat) return T_mat is
    S : T_mat; -- S la matrice Somme
    val : Float; -- Valeur de la case (i,j)
    begin
        if M1.nombre_colonne = M2.nombre_colonne and M1.nombre_ligne = M2.nombre_ligne then
            S.nombre_colonne := M1.nombre_colonne;
            S.nombre_ligne := M1.nombre_ligne;
            for i in 1..S.nombre_ligne loop
                for j in 1..S.nombre_colonne loop
                    val := Valeur(M1,i,j) + Valeur(M2,i,j);
                    Enregistrer(S.Mat,i,j,Val);
                end loop;
            end loop;
        -- Si les tailles de matrices ne sont pas les mêmes, alors on léve l'exception
        else
            raise Taille_Differente_Addition;
        end if;
        return S;
    end "+";

    --Multiplication de deux matrices (attention, on fait M1*M2 et non M2*M1)
    --Renvoie l'exception Taille_Incompatible_Multiplication si les dimenssions ne permettent pas la multiplication
    function "*" (M1, M2 : in T_mat) return T_mat is
        Produit: T_mat;
        s: float;
    begin
        if M1.nombre_colonne = M2.nombre_ligne then
            Produit.nombre_ligne := M1.nombre_ligne;
            Produit.nombre_colonne := M2.nombre_colonne;
            for i in 1..Produit.nombre_ligne loop
                for j in 1..Produit.nombre_colonne loop
                    s := 0.0;
                    for k in 1..M1.nombre_colonne loop
                        s := s + Valeur(M1,i,k)*Valeur(M2,k,j);
                    end loop;
                    Enregistrer(Produit.Mat,i,j,s);
                end loop;
            end loop;
            return Produit;
        else
            raise Taille_Incompatible_Multiplication;
        end if;
    end "*";
    
    --Multiplication d'une matrice par un scalaire
    function "*" (lambda:in float ; M:in T_mat) return T_mat is
        T : T_mat;
    begin
        T.nombre_colonne := M.nombre_colonne;
        T.nombre_ligne := M.nombre_ligne;
        for i in 1..M.nombre_ligne loop
            for j in 1..M.nombre_colonne loop
                Enregistrer(T,i,j,lambda * valeur(M,i,j));
            end loop;
        end loop;
        return T;
    end "*";

    --Multiplication d'un vecteur par une matrice
    function "*" (V : in T_vecteur; M : in T_mat) return T_vecteur is
        Produit: T_vecteur;
        s: float;
    begin
        Produit.longueur := M.nombre_colonne;
        if V.longueur = M.nombre_ligne then
            for j in 1..Produit.longueur loop
                s := 0.0;
                for k in 1..M.nombre_ligne loop
                    s := s + V.tab(k)*Valeur(M,k,j);
                end loop;
                Produit.Tab(j) := s;
            end loop;
            return Produit;
        else
            raise Taille_Incompatible_Multiplication;
        end if;
    end "*";

    function "*" (lambda:in float ; V :in T_vecteur) return T_vecteur is
        res : T_vecteur;
    begin
        res.longueur := V.longueur;
        for i in 1..res.longueur loop
            res.tab(i) := lambda * V.tab(i);
        end loop;
        return res;
    end "*";

    procedure Afficher(V: T_vecteur) is
    begin
    Put("Vecteur : (");
    for i in 1..V.longueur loop
        Put(V.tab(i));
        if i < V.longueur then
            Put(", ");
        end if;
    end loop;
    Put_Line(")");
    end Afficher;

    function max(V:in T_vecteur) return integer is
        maximum: Float;
        indice : integer;
    begin
            maximum := 0.0;
            indice := 0;
            for i in 1..V.longueur loop
                if V.tab(i) >= maximum then
                    maximum := V.tab(i);
                    indice := i;
                else
                    Null;
                end if;
            end loop;
            return indice;
    end max; 

    function norme (V : in T_vecteur) return float is
        s : float;
    begin
        s := 0.0;
        for i in 1..V.longueur loop
            s := s + V.tab(i)*V.tab(i);
        end loop;
        return sqrt(s);
    end norme;

end Matrice_creuse;

-- Architecture
-- Proportion de travail
-- Nombres d'heures passé