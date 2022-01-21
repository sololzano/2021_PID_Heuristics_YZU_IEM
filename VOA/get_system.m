% System function
function sr = get_system(system)
    arguments
        system string = "PITCH";
    end
    s = tf('s');
    if system == "PITCH"
        sr = (1.151*s+0.1774)/(s^3+0.739*s^2+0.921*s);
    end
    if system == "DC_SPEED"
        sr = tf(0.023, [0.005, 0.01002, 0.000559]);
    end
    if system == "DC_ANGLE"
        J = 3.2284E-6;
        b = 3.5077E-6;
        K = 0.0274;
        R = 4;
        L = 2.75E-6;
        sr = K/(s*((J*s+b)*(L*s+R)+K^2));
    end
    if system == "BALL"
        m = 0.111;
        R = 0.015;
        g = -9.8;
        L = 1.0;
        d = 0.03;
        J = 9.99e-6;
        sr = -m*g*d/L/(J/R^2+m)/s^2;
    end
    if system == "PENDULUM"
        M = 0.5;
        m = 0.2;
        b = 0.1;
        I = 0.006;
        g = 9.8;
        l = 0.3;
        q = (M+m)*(I+m*l^2)-(m*l)^2;
        sr = (m*l*s/q)/(s^3 + (b*(I + m*l^2))*s^2/q - ((M + m)*m*g*l)*s/q - b*m*g*l/q);
    end
    if system == "AVR"
        Ka = 10.0;
        Ke = 1.0;
        Kg = 1.0;
        ta = 0.1;
        te = 0.4;
        tg = 1.0;
        amp = Ka / (1 + ta*s);
        exc = Ke / (1 + te*s);
        gen = Kg / (1 + tg*s);
        sr = amp * exc * gen;
    end
    if system == "WHALE_1"
        sr = (104.9)/(s^2 + 103.5*s + 2617);
    end
    if system == "WHALE_2"
        sr = (25.28*s^2 + 22.2*s + 3) /...
            (s^5 + 16.6*s^4 + 25.41*s^3 + 17.2*s^2 + 12*s + 1);
    end
    if system == "WHALE_3"
        sr = 1 / (s^4 + 6*s^3 + 11*s^2 + 6*s);
    end
end
