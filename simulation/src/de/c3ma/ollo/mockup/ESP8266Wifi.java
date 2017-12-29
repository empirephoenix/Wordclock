package de.c3ma.ollo.mockup;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import org.luaj.vm2.LuaTable;
import org.luaj.vm2.LuaValue;
import org.luaj.vm2.lib.OneArgFunction;
import org.luaj.vm2.lib.TwoArgFunction;
import org.luaj.vm2.lib.ZeroArgFunction;

import de.c3ma.ollo.LuaSimulation;

/**
 * created at 29.12.2017 - 01:29:40<br />
 * creator: ollo<br />
 * project: WifiEmulation<br />
 * $Id: $<br />
 * @author ollo<br />
 */
public class ESP8266Wifi extends TwoArgFunction {

    @Override
    public LuaValue call(LuaValue modname, LuaValue env) {
        env.checkglobals();
        final LuaTable wifi = new LuaTable();
        wifi.set("setmode", new SetModeFunction());
        wifi.set("ap", new ApFunction());
        wifi.set("SOFTAP", "SOFTAP");
        env.set("wifi", wifi);
        env.get("package").get("loaded").set("wifi", wifi);        
        return wifi;
    }

    private class SetModeFunction extends OneArgFunction {

        @Override
        public LuaValue call(LuaValue apmode) {
            final String APmodeString = apmode.checkjstring();
            System.out.println("[Wifi] set mode " + APmodeString);
            return LuaValue.valueOf(true);
        }
        
    }
    
    private class ApFunction extends TwoArgFunction {

        @Override
        public LuaValue call(LuaValue modname, LuaValue env) {
            final LuaTable ap = new LuaTable();
            ap.set("config", new ConfigFunction());
            env.set("ap", ap);
            env.get("package").get("loaded").set("wifi.ap", ap); 
            return ap;
        }
        
    }
    
    private class ConfigFunction extends OneArgFunction {

        @Override
        public LuaValue call(LuaValue arg) {
            System.out.println("[Wifi] config");
            return LuaValue.valueOf(true);
        }
        
    }
}
