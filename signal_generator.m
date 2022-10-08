fs = input('Enter sampling frequency: ');
Ti = input('Enter start of time scale: ');
Tf = input('Enter end of time scale: ');
Nb = input('Enter number of breakpoints: ');
t = linspace(Ti,Tf,(Tf-Ti)*fs);
time_current = Ti;
signal_info = zeros(5, Nb+1); %1 is type, 2 is breakpoint,
%3 up to 5 are the properties of the signal
output_signal = [];

breakpoints = zeros(1, Nb);
for i = 1:Nb
  breakpoints(1,i) = input(sprintf('Enter position of breakpoint %d: ',i-1));
end
fprintf(['1. DC\n2. Ramp\n3. General order polynomial',...
'\n4. Exponential\n5. Sinusoidal\n']);
for i = 0:Nb
  if ((i == Nb) && (Nb == 0))
    ti = Ti;
    tf = Tf;
  elseif (i == 0)
    ti = Ti;
    tf = breakpoints(1,i+1);
  elseif (i == Nb)
    ti = breakpoints(1,i);
    tf = Tf;
  else
    ti = breakpoints(1,i);
    tf = breakpoints(1,i+1);
  end
  T = tf - ti;
  ti
  tf
  T
  
  k = i + 1;
  while true
    signal_info(1,k) = input(sprintf(['Enter corresponding number (1-5)',...
    ' of signal #%d''s type: '], k));
    if ((5>=signal_info(1,k)) && (signal_info(1,k)>=1))
      break;
    end
  end


  switch signal_info(1,k)
    case 1 %DC, index 3 is amplitude
      signal_info(3,k) = input('Enter amplitude: ');
      output_signal = [output_signal (signal_info(3,k) * ones(1,T*fs))];
    case 2 %Ramp, index 3 is slope, 4 is intercept
      signal_info(3,k) = input('Enter slope: ');
      signal_info(4,k) = input('Enter intercept: ');
      time = linspace(ti, tf, T*fs);
      output_signal = [output_signal (signal_info(3,k)*time + signal_info(4,k))];
    case 3 %General order polynomial, index 3 is amplitude, 4 is power, 5 is intercept
      signal_info(4,k) = input('Enter power: ');
      time = linspace(ti, tf, T*fs);
      if (signal_info(4,k) > 0)
        signal_info(3,k) = input(sprintf('Enter amplitude for X^%d: ',signal_info(4,k)));
        temp = signal_info(3,k) * (time .^signal_info(4,k));
        for j = (signal_info(4,k)-1):-1:1
          signal_info(3,k) = input(sprintf('Enter amplitude for X^%d: ',j));
          temp = temp + signal_info(3,k) * (time .^j);
        end
      end
      signal_info(5,k) = input('Enter amplitude for X^0 (intercept): ');
      temp = temp + signal_info(5,k);
      output_signal = [output_signal temp];
    case 4 %Exponential, index 3 is amplitude, 4 is exponent
      signal_info(3,k) = input('Enter amplitude: ');
      signal_info(4,k) = input('Enter exponent: ');
      time = linspace(ti, tf, T*fs);
      temp = (signal_info(3,k) * exp(signal_info(4,k)*time));
      output_signal = [output_signal temp];
    case 5 %Sinusoidal, index 3 is amplitude, 4 is frequency, 5 is phase
      signal_info(3,k) = input('Enter amplitude: ');
      signal_info(4,k) = input('Enter frequency: ');
      signal_info(5,k) = input('Enter phase: ');
      time = linspace(ti, tf, T*fs);
      temp = (signal_info(3,k)*sin(2*pi*signal_info(4,k)*time+signal_info(5,k)));
      output_signal = [output_signal temp];
  end
end

figure('Name','Output signal','NumberTitle','off');
plot(t, output_signal,'LineWidth',1);
title('Output signal');
grid on;

while true
  fprintf(['1. Amplitude scaling\n2. Time reversal\n3. Time shift\n',...
  '4. Expanding signal\n5. Compressing signal\n6. Display\n7. None\n']);
  choice = input('What operation (1-7) would you like to perform on the signal: ');
  if ((choice<1) || (choice>7))
    continue
  end
  switch choice
    case 1
      amp = input('Enter amplitude value: ');
      output_signal = amp*output_signal;
    case 2
      t = flip(-t);
      output_signal = flip(output_signal);
      disp('Time reversed.');
    case 3
      shift = input('Enter time shift value: ');
      t = t + shift;
    case 4
      expand = input('Enter expand value: ');
      t = t*expand;
    case 5
      compress = input('Enter compress value: ');
      t = t/compress;
    case 6
      figure('Name','Output signal','NumberTitle','off');
      plot(t, output_signal,'LineWidth',1);
      title('Output signal');
      grid on;
    case 7
      break
  end
end

figure('Name','Final Output signal','NumberTitle','off');
plot(t, output_signal,'LineWidth',1);
title('Final Output signal');
grid on;