module jamvm;

import std::io;
import types;

fn int main(String[] args)
{
	io::printfn("Hello, World! %d", types::Status.OK.ordinal);
	return 0;
}
