@license{
  Copyright (c) 2009-2013 CWI
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
@contributor{Bert Lisser - Bert.Lisser@cwi.nl (CWI)}

module analysis::formalconcepts::FCA

import Set;
import Map;
import Relation;
import lang::dot::Dot;
import IO;

@doc{
Synopsis: Data Types belonging to Formal Concept Analysis.
}
public alias FormalContext[&Object, &Attribute] = rel[&Object, &Attribute];
public alias Concept[&Object, &Attribute] = tuple[set[&Object] objects, set[&Attribute] attributes];
public alias ConceptLattice[&Object, &Attribute] = rel[Concept[&Object, &Attribute], Concept[&Object, &Attribute]];

public alias Object2Attributes[&Object, &Attribute] = map[&Object, set[&Attribute]];
public alias Attribute2Objects[&Attribute, &Object] = map[&Attribute, set[&Object]];

                                                     
@doc{
Synopsis: Computes Concept Lattice given the Object Attribute Relation.
}
public ConceptLattice[&Object, &Attribute] fca (FormalContext[&Object, &Attribute] fc) {
    rel[set[&Attribute], set[&Attribute]] lat = createAttributeLattice(fc);
    return {<<tau(fc, c1), c1>, <tau(fc, c2), c2>>|<set[&Attribute] c1, set[&Attribute] c2><-lat};
}

@doc{
Synopsis: Computes Dot Graph from Concept Lattice.
}
public DotGraph toDot(ConceptLattice[&Object, &Attribute] cl) {
   return toDot(cl, true);
   }
   
public DotGraph toDot(ConceptLattice[&Object, &Attribute] cl, bool lab) {
     map[Concept[&Object, &Attribute], int] z = makeNodes(cl);
     set[Concept[&Object, &Attribute]] d = domain(z);
     Stms nodes = [];
     for (Concept[&Object, &Attribute] c <- d) {
       nodes += compose(c, z, lab);
     }  
     Stms edges =   [ E("\"<z[x[0]]>\"", "\"<z[x[1]]>\"") | x<-cl]; 
     return digraph("fca", 
      [NODE( [<"style","filled">, <"fillcolor","cornsilk">,<"fontcolor","blue">,<"shape","ellipse">])] 
         +nodes+edges); 
     }
     
public Dotline toDotline(ConceptLattice[&Object, &Attribute] cl) {
     return <toDot(cl, false), toOutline(cl)>;
     }

     
public Outline toOutline(ConceptLattice[&Object, &Attribute] cl) {
     map[Concept[&Object, &Attribute], int] z = makeNodes(cl);
     set[Concept[&Object, &Attribute]] d = domain(z);
     Outline r = (z[c]:["<c[0]>", "<c[1]>"] | Concept[&Object, &Attribute] c <- d);
     return r;
     } 
        
public FormalContext[&Object, &Attribute] toFormalContext(Object2Attributes objects) {
    return {<object, attribute>  | &Object object <- domain(objects), 
            &Attribute attribute <- objects[object]}; 
    }

public FormalContext[&Object, &Attribute] toFormalContext(Attribute2Objects attributes) {
    return {<object, attribute>  | &Attribute attribute <- domain(attributes), 
            &Object object <- attributes[attribute]}; 
    }     
/*---------------------------------------------------------------------------------------------*/

set[&T] intersection(set[set[&T]] st)
{
  set[&T] result = isEmpty(st)?{}:getOneFrom(st);
  for(set[&T] elm <- st){
    result = result & elm;
  }
  return result;
}

set[&T] union(set[set[&T]] st)
{
  set[&T] result = {};
  for(set[&T] elm <- st){
    result += elm;
  }
  return result;
} 

bool isSubset(set[set[&T]] candidate, set[&T] s ) {
         for (set[&T] c <- candidate) 
         if (s<c) return true;
         return false;
     }   

set[&Attribute] sigma(FormalContext[&Object, &Attribute] fc, set[&Object] objects) {
      return isEmpty(objects)?fc<1>:intersection({{y|<x,y><-fc}| x <- objects});
      }
      
set[&Object] tau(FormalContext[&Object, &Attribute] fc, set[&Attributes] attributes) {
      return isEmpty(attributes)?fc<0>:intersection({{x|<x,y><-fc}|y <- attributes});
      }
      
set[set[&T]] maxincl(set[set[&T]] c) {return {s|set[&T] s <- c, !isSubset(c, s)};}

rel[set[&Attribute], set[&Attribute]] createAttributeLattice(FormalContext[&Object, &Attribute] fc) {
     set[&Object] G = domain(fc);
     set[&Attribute] M = range(fc);
     set[set[&Attribute]] layer = {M};
     set[set[&Attribute]] B = {sigma(fc, {g}) | g <- G};
     rel[set[&Attribute], set[&Attribute]] r = {};
     while (!isEmpty(layer)&& layer!={{}}) {
         set[set[&Attribute]] nextLayer = {};
         for (set[&Attribute] m<-layer) {
           set[set[&Attribute]] cover = maxincl({b&m|set[&Attribute] b<-B,  (b&m)<m});
           for (set[&Attribute] cov<-cover) r+= {<m, cov>};
           nextLayer += cover;
           }
         layer = nextLayer;      
         }
     return r;
     }
     
 /*-----------------------------------------------------------------------------------*/ 
    
map[Concept[&Object, &Attribute], int] makeNodes(ConceptLattice[&Object, &Attribute] q) {
     set[Concept[&Object, &Attribute]] c = carrier(q);
     int i = 0;
     map[Concept[&Object, &Attribute], int] r = ();
     for (Concept[&Object, &Attribute] b<-c) {
          if (!(r[b])?) {
              r[b] = i;
              i=i+1;
              }
          }
     return r;
     }
     
set[&Attribute] newAdded1(ConceptLattice[&Object, &Attribute] q,  Concept[&Object, &Attribute] c) {
     set[Concept[&Object, &Attribute]] parents = range(domainR(q, {c}));
     return c[1] - union({p[1]|Concept[&Object, &Attribute] p <-parents});
     }
 
set[&Concept] newAdded0(ConceptLattice[&Object, &Attribute] q, Concept[&Object, &Attribute] c) {
     set[concept_t] parents = domain(rangeR(q, {c}));
     return c[0] - union({p[0]|Concept[&Object, &Attribute] p <-parents});
     }  

Stm compose(Concept[&Object, &Attribute] c, map[Concept[&Object, &Attribute], int] z, bool lab) {
     return N("\"<z[c]>\"", lab?[<"label", "<c>">]:[]);
     }     
