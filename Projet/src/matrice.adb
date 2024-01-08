with Ada.Numerics.Elementary_Functions; use  Ada.Numerics.Elementary_Functions;
with Ada.Text_IO;			use Ada.Text_IO;
with Ada.Float_Text_IO;		use Ada.Float_Text_IO;

package body matrice is
    
    procedure Initialiser_matrice(l:in Integer; c:in Integer; x:in float; M:out T_mat) is
    begin
        for i in 1..l loop
            for j in 1..c loop
                M.Mat(i,j) := x;
            end loop;
        end loop;
        M.nombre_colonne := c;
        M.nombre_ligne := l;
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
    
    procedure Enregistrer(M:in out T_mat; ligne:in Integer; colonne:in Integer; valeur:in float) is
    begin
        if ligne > 0 and ligne < M.nombre_ligne and colonne > 0 and colonne < M.nombre_colonne then
            M.Mat(ligne,colonne) := valeur;
        else
            raise Case_Hors_Bornes;
        end if;
    end Enregistrer;    
    
    
    procedure Modifier_ligne(M:in out T_mat; ligne:in Integer; valeur:in float) is
    begin
        if ligne > 0 and ligne < M.nombre_ligne then
            for i in 1..M.nombre_colonne loop
                M.Mat(ligne,i) := valeur;
            end loop;
        else
            raise Ligne_Hors_Bornes;
        end if;                
    end Modifier_ligne;

    function Ligne_Vide (M :in T_mat; l:in Integer) return Boolean is
        res : Boolean;
    begin 
        res := True;
        for j in 1..M.nombre_colonne loop
            if abs(M.Mat(l,j)) > 0.00001 then
                res := False;
            else
                Null;
            end if;
        end loop;
        return res;
    end Ligne_Vide;
    
    function "+" (M1,M2 : in T_mat) return T_mat is
        Somme: T_mat;
    begin
        
        if M1.nombre_colonne = M2.nombre_colonne and M1.nombre_ligne = M2.nombre_ligne then
            Somme.nombre_colonne := M1.nombre_colonne;
            Somme.nombre_ligne := M2.nombre_ligne;
            for i in 1..M1.nombre_ligne loop
                for j in 1..M2.nombre_colonne loop
                    Somme.Mat(i,j) := M1.Mat(i,j) + M2.Mat(i,j);
                end loop;
            end loop;
            return Somme;
        else
            raise Taille_Differente_Addition;
        end if;   
    end "+";

    function "+" (V1, V2: in T_vecteur) return T_vecteur is
        Somme: T_vecteur;
    begin
        if V1.longueur = V2.longueur then
            Somme.longueur := V1.longueur;
            for i in 1..Somme.longueur loop
                Somme.tab(i) := V1.tab(i) + V2.tab(i);
            end loop;
            return Somme;
        else
            raise Taille_Differente_Addition;
        end if;   
    end "+";
    
    
    function "*" (M1,M2:in T_mat) return T_mat is
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
                        s := s + M1.Mat(i,k)*M2.Mat(k,j);
                    end loop;
                    Produit.Mat(i,j) := s;
                end loop;
            end loop;
            return Produit;
        else
            raise Taille_Incompatible_Multiplication;
        end if;                        
    end "*";
    
    
    function Transpose(M:in T_mat) return T_mat is
        T : T_mat;
    begin
        T.nombre_colonne := M.nombre_ligne;
        T.nombre_ligne := M.nombre_colonne;
        for i in 1..M.nombre_ligne loop
            for j in 1..M.nombre_colonne loop
                T.Mat(j,i) := M.Mat(i,j);
            end loop;
        end loop;
        return T;
    end Transpose;
    
    function "*" (lambda:in float ; M:in T_mat) return T_mat is
        T : T_mat;
    begin
        T.nombre_colonne := M.nombre_colonne;
        T.nombre_ligne := M.nombre_ligne;
        for i in 1..M.nombre_ligne loop
            for j in 1..M.nombre_colonne loop
                T.Mat(i,j) := lambda * M.mat(i,j);
            end loop;
        end loop;
        return T;
    end "*";

    function norme (V : in T_vecteur) return float is
        s : float;
    begin
        s := 0.0;
        for i in 1..V.longueur loop
            s := s + V.tab(i)*V.tab(i);
        end loop;
        return sqrt(s);
    end norme;

    procedure Afficher (M : in T_mat) is
    begin
        New_Line;
        for i in 1..M.nombre_ligne loop
            for j in 1..M.nombre_colonne loop
                Put (M.Mat(i, j), 6, 2);
                Put(" ");
            end loop;
            New_Line;
        end loop;
    end Afficher;

    function "*" (V : in T_vecteur; M : in T_mat) return T_vecteur is
        Produit: T_vecteur;
        s: float;
    begin
        Produit.longueur := M.nombre_colonne;
        if V.longueur = M.nombre_ligne then
            for j in 1..Produit.longueur loop
                s := 0.0;
                for k in 1..M.nombre_ligne loop
                    s := s + V.tab(k)*M.Mat(k,j);
                end loop;
                Produit.Tab(j) := s;
            end loop;
            return Produit;
        else
            raise Taille_Incompatible_Multiplication;
        end if;
    end "*";

    procedure echange(V: in out T_vecteur; i, j: Integer) is
      Temp: Float;
    begin
      Temp := V.tab(i);
      V.tab(i) := V.tab(j);
      V.tab(j) := Temp;
    end echange;

   procedure Quicksort(V: in out T_vecteur; bas, haut: Integer; Indices_tries : out T_vecteur) is
      i, j: Integer;
      Pivot : Float;
   begin
    -- Création Indices_triés
    Indices_tries.longueur := V.longueur;
    for i in 1..Indices_tries.longueur loop
        Indices_tries.tab(i) := Float(i) -1.0 ;
    end loop;
    if bas < haut then
         Pivot := V.tab((bas + haut) / 2);
         i := bas;
         j := haut;
         while i <= j loop
            while V.tab(i) < Pivot loop
               i := i + 1;
            end loop;
            while V.tab(j) > Pivot loop
               j := j - 1;
            end loop;
            echange(V, i, j);
            echange(Indices_tries, i, j);
            i := i + 1;
            j := j - 1;
         end loop;
         Quicksort(V, bas, j, Indices_tries);
         Quicksort(V, i, haut, Indices_tries);
    end if;
   end Quicksort;

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

    
    function Ligne_max(V:in T_vecteur) return integer is
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
    end Ligne_max;    
    
end matrice;