package de.c3ma.ollo.mockup;

import org.luaj.vm2.LuaTable;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.Varargs;
import org.luaj.vm2.lib.TwoArgFunction;
import org.luaj.vm2.lib.VarArgFunction;

/**
 * created at 08.05.2019 - 21:33:04<br />
 * creator: ollo<br />
 * project: ESP8266GPIO Emulation<br />
 * $Id: $<br />
 * @author ollo<br />
 */
public class ESP8266GPIO extends TwoArgFunction {

	@Override
	public LuaValue call(LuaValue modname, LuaValue env) {
		env.checkglobals();
        final LuaTable gpio = new LuaTable();
        gpio.set("mode", new Mode());
        gpio.set("read", new Read(this));
        env.set("gpio", gpio);
        env.get("package").get("loaded").set("gpio", gpio);
        return gpio;
	}
	
	private class Read extends VarArgFunction {
		
		private ESP8266GPIO mGpio = null;
		
		Read(ESP8266GPIO gpio) {
			this.mGpio = gpio;
		}
    	
        public Varargs invoke(Varargs varargs) {
        	int pin = varargs.toint(0);
        	//FIXME add here something to simulate a pin pressing
            return LuaValue.valueOf((int)1);
        }
    }
	
	private class Mode extends VarArgFunction {
    	
        public Varargs invoke(Varargs varargs) {
        	System.out.println("[GPIO] mode GPIO" + varargs.toint(0) + "=" + varargs.toint(1));
            return LuaValue.valueOf(true);
        }
    }
}
