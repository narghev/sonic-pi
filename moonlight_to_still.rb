FINAL_SLEEP_TIME = 0.3

define :moonlight_bass do
  use_synth :piano
  time_of_number_of_notes = 0.9
  release_time = 10
  
  play :A1, release: release_time
  sleep(time_of_number_of_notes * 4)
  play :G1, release: release_time
  sleep(time_of_number_of_notes * 4)
  play :F1, release: release_time
  sleep(time_of_number_of_notes * 2)
  play :D1, release: release_time
  sleep(time_of_number_of_notes * 2)
  play :E1, release: release_time
  sleep(time_of_number_of_notes * 2)
  play :E1, release: release_time
  sleep(time_of_number_of_notes * 2)
  play :A1, release: release_time
end

define :play_moonlight_note do |note|
  use_synth :piano
  play(note)
  sleep(FINAL_SLEEP_TIME)
end

define :moonlight_melody do
  use_synth :piano
  
  8.times do
    play_moonlight_note(:E2)
    play_moonlight_note(:A2)
    play_moonlight_note(:C3)
  end
  
  2.times do
    play_moonlight_note(:F2)
    play_moonlight_note(:A2)
    play_moonlight_note(:C3)
  end
  
  2.times do
    play_moonlight_note(:F2)
    play_moonlight_note(:As2)
    play_moonlight_note(:D3)
  end
  
  1.times do
    play_moonlight_note(:E2)
    play_moonlight_note(:Gs2)
    play_moonlight_note(:D3)
  end
  
  1.times do
    play_moonlight_note(:E2)
    play_moonlight_note(:A2)
    play_moonlight_note(:C3)
  end
  
  1.times do
    play_moonlight_note(:E2)
    play_moonlight_note(:A2)
    play_moonlight_note(:B2)
  end
  
  1.times do
    play_moonlight_note(:E2)
    play_moonlight_note(:Gs2)
    play_moonlight_note(:B2)
  end
end

define :moonlight_to_still do
  transition_notes = [:E2, :A2, :C3, :E3, :A3, :C4, :E4, :A4, :C5, :E5, :A5]
  
  (0..transition_notes.length - 3).to_a.each do |index|
    play_moonlight_note(transition_notes[index])
    play_moonlight_note transition_notes[index + 1]
    play_moonlight_note transition_notes[index + 2]
  end
end

define :accelerate_to_still do
  use_synth :piano
  notes = [:C5, :E5, :A5]
  
  sleep_time = FINAL_SLEEP_TIME
  
  while sleep_time > 0.1 do
      notes.each do |note|
        play(note)
        sleep(sleep_time)
      end
      
      sleep(FINAL_SLEEP_TIME - sleep_time)
      sleep_time *= 0.9
    end
  end
  
  define :still_dre do |synth = :piano|
    
    use_synth synth
    
    8.times do
      play [:C5, :E5, :A5], amp: 2
      sleep(FINAL_SLEEP_TIME)
    end
    
    3.times do
      play [:B4, :E5, :A5], amp: 2
      sleep(FINAL_SLEEP_TIME)
    end
    
    5.times do
      play [:B4, :E5, :G5], amp: 2
      sleep(FINAL_SLEEP_TIME)
    end
  end
  
  define :still_dre_drums do
    iteration = 0
    while iteration < 15 do
        sample :drum_cymbal_closed
        sample :drum_bass_hard if iteration % 4 == 0
        sample :drum_snare_hard if iteration % 2 == 0 && iteration % 4 != 0
        sleep(FINAL_SLEEP_TIME)
        iteration += 1
      end
    end
    
with_fx :reverb do
  in_thread do
    moonlight_bass
  end
  moonlight_melody
  moonlight_to_still
  accelerate_to_still
  still_dre
  2.times do
    in_thread do
      still_dre_drums
    end
    still_dre
  end
  still_dre :dark_ambience
  play [:C5, :E5, :A5], release: 2
end