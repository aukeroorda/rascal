package org.rascalmpl.semantics.dynamic;

import java.util.List;
import org.eclipse.imp.pdb.facts.INode;
import org.rascalmpl.ast.NullASTVisitor;

public abstract class NoElseMayFollow extends org.rascalmpl.ast.NoElseMayFollow {

	public NoElseMayFollow(INode __param1) {
		super(__param1);
	}

	static public class Ambiguity extends org.rascalmpl.ast.NoElseMayFollow.Ambiguity {

		public Ambiguity(INode __param1, List<org.rascalmpl.ast.NoElseMayFollow> __param2) {
			super(__param1, __param2);
		}

		@Override
		public <T> T __evaluate(NullASTVisitor<T> __eval) {
			return null;
		}

	}

	static public class Default extends org.rascalmpl.ast.NoElseMayFollow.Default {

		public Default(INode __param1) {
			super(__param1);
		}

		@Override
		public <T> T __evaluate(NullASTVisitor<T> __eval) {
			return null;
		}

	}
}