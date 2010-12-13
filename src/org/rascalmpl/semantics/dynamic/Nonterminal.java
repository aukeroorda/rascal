package org.rascalmpl.semantics.dynamic;

import java.lang.String;
import java.util.List;
import org.eclipse.imp.pdb.facts.INode;
import org.rascalmpl.ast.NullASTVisitor;

public abstract class Nonterminal extends org.rascalmpl.ast.Nonterminal {

	public Nonterminal(INode __param1) {
		super(__param1);
	}

	static public class Lexical extends org.rascalmpl.ast.Nonterminal.Lexical {

		public Lexical(INode __param1, String __param2) {
			super(__param1, __param2);
		}

		@Override
		public <T> T __evaluate(NullASTVisitor<T> __eval) {
			return null;
		}

	}

	static public class Ambiguity extends org.rascalmpl.ast.Nonterminal.Ambiguity {

		public Ambiguity(INode __param1, List<org.rascalmpl.ast.Nonterminal> __param2) {
			super(__param1, __param2);
		}

		@Override
		public <T> T __evaluate(NullASTVisitor<T> __eval) {
			return null;
		}

	}
}