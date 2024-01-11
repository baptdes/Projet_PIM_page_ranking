package body Vecteurs is

    -- Initialiser un vecteur

        procedure Initialiser_vecteur(l : in Integer; x:in T_valeur; V : out T_vecteur) is
        begin
            for i in 1..l loop
                V.Tab(i) := x;
            end loop;
            V.longueur := l;
        end Initialiser_vecteur;

    -- Opérations de bases

        function "*" (lambda:in T_valeur ; V :in T_vecteur) return T_vecteur is
            res : T_vecteur;
        begin
            res.longueur := V.longueur;
            for i in 1..res.longueur loop
                res.tab(i) := lambda * V.tab(i);
            end loop;
            return res;
        end "*";

        -- Somme entre deux vecteurs
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
                raise Taille_Differente;
            end if;   
        end "+";

        -- Somme entre un vecteur et une valeur
        function "+"(V:in T_vecteur;x : in T_valeur) return T_vecteur is
            V_somme : T_vecteur;
        begin
            V_somme.longueur := V.longueur;
            for i in 1..V.longueur loop
                V_somme.tab(i) := V.tab(i) + x;
            end loop;
            return V_somme;
        end "+";

    --Calculs/tri sur des vecteurs

        function max(V:in T_vecteur) return integer is
            maximum: T_valeur;
            indice : integer;
        begin
            maximum := V.tab(1);
            indice := 1;
            for i in 2..V.longueur loop
                if V.tab(i) >= maximum then
                    maximum := V.tab(i);
                    indice := i;
                else
                    Null;
                end if;
            end loop;
            return indice;
        end max;

        function somme(V:in T_vecteur) return T_valeur is
            somme : T_valeur;
        begin
            somme := V.tab(1);
            for i in 2..V.longueur loop
                somme := somme + V.tab(i);
            end loop;
            return somme;
        end somme;

        function distance (V1 : in T_vecteur;V2 : in T_vecteur) return T_valeur is
            s : T_valeur;
        begin
            if V1.longueur /= V2.longueur then
                raise Taille_Differente;
            end if;
            s := (V1.tab(1) - V2.tab(1))*(V1.tab(1) - V2.tab(1));
            for i in 2..V1.longueur loop
                s := s + (V1.tab(i) - V2.tab(i))*(V1.tab(i) - V2.tab(i));
            end loop;
            return sqrt(s);
        end distance;

end Vecteurs;