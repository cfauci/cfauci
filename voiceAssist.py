#!/usr/bin/env python
# coding: utf-8

# Notes: requires Python 3.10 (any higher and whisper fails, any lower and other models fail
#requires ollama set up
#Instructions for setting up whisper (there are at least three other ways that failed for me setting it up): 
#https://medium.com/@bhuwanmishra_59371/a-starter-guide-to-whisper-cpp-f238817fd876

import sounddevice as sd
import numpy as np
import wave
import whisper
import subprocess
import re

samplingRate=16000 #set to the same as whisper

# you would need to make an adjustment here to account for a trigger word. Whatever control sequence you have to keep the mic 
#listening for a trigger word, would then trigger this program.

# Record audio using sounddevice
duration=5 #this can be changed to a different length of time, or some other trigger (maybe dead air i'm not sure about that one)
recordedAudio = sd.rec(
    int(duration * samplingRate),
    samplerate=samplingRate,
    channels=1,
    dtype=np.int16,
)
sd.wait()  # Wait until recording is finished


#test code to play back recording to check contents
#sd.play(recordedAudio, samplingRate)
#sd.wait()


# Save audio to WAV file
audio_file = "testing.wav"
with wave.open(audio_file, "w") as wf:
    wf.setnchannels(1)
    wf.setsampwidth(2)  # 16-bit audio
    wf.setframerate(samplingRate)
    wf.writeframes(recordedAudio.tobytes())


WHISPER_BINARY_PATH = "/usr/local/bin/whisper-cpp" # brew install
MODEL_PATH = "/Users/cfauci/github/whisper.cpp/models/ggml-base.en.bin" #cloned copy of repository with all the models (in notes at top)

extracted_text = ""
try:
    result = subprocess.run(
        [
            WHISPER_BINARY_PATH,
            "-m",
            MODEL_PATH,
            "-f",
            audio_file,
            "-l",
            "en",
            "-otxt",
        ],
        capture_output=True,
        text=True,
    )
    # Display the transcription
    transcription = result.stdout.strip()
except FileNotFoundError:
    st.error(
        "Whisper.cpp binary not found. Make sure the path to the binary is correct."
    )
print(transcription)    


#make sure you have a terminal running ollama (ollama serve call)

def run_ollama_command(model, prompt):
    try:
        # Execute the ollama command using subprocess
        result = subprocess.run(
            ["ollama", "run", model],
            input=prompt,
            text=True,
            capture_output=True,
            check=True,
        )

        # Output the result from Ollama
        print("Response from Ollama:")
        print(result.stdout)
        return result.stdout

    except subprocess.CalledProcessError as e:
        # Handle errors in case of a problem with the command
        print("Error executing Ollama command:")
        print(e.stderr)


# Parse the transcription text
# Use regex to find all text after timestamps
matches = re.findall(r"\] *(.*)", transcription)

# Concatenate all extracted text
concatenated_text = " ".join(matches)

# Call ollama to get an answer
prompt = f"""
Please ignore the text [BLANK_AUDIO]. Given this question: "{concatenated_text}, please answer it in less than 15 words."
"""
answer = run_ollama_command(model="qwen:0.5b", prompt=prompt)

#this is the final text output, variable is answer, 
#definitely remove the "response from Ollama" string, but you could add some other framing phrase


# This is my alternative to using the NeMo package(that version is below the "#engine.runAndWait() call", which is among the problems I'm having. 
#I think we may be able to simplify away from whisper with something similar (python prebuilt speech to text)

#import pyttsx3
#engine = pyttsx3.init()
#engine.say(answer)
#engine.runAndWait()


# this is the part of that article where I couldn't get it to build. I think the problem was in my venv.

#if you wanted to make this part work, you will need pytorch, torchvision and torchaudio, as well as the nemo-tts module

# Integrate NVIDIA NeMo TTS to read the answer from ollama
#if answer:
 #   try:
        # Load the FastPitch and HiFi-GAN models from NeMo
 #       fastpitch_model = nemo_tts.models.FastPitchModel.from_pretrained(
 #           model_name="tts_en_fastpitch"
  #      )
   #     hifigan_model = nemo_tts.models.HifiGanModel.from_pretrained(
    #        model_name="tts_en_lj_hifigan_ft_mixerttsx"
    #    )

        # Set the FastPitch model to evaluation mode
    #    fastpitch_model.eval()
    #    parsed_text = fastpitch_model.parse(answer)
    #    spectrogram = fastpitch_model.generate_spectrogram(tokens=parsed_text)

        # Convert the spectrogram into an audio waveform using HiFi-GAN vocoder
    #    hifigan_model.eval()
    #    audio = hifigan_model.convert_spectrogram_to_audio(spec=spectrogram)

        # Save the audio to a byte stream
    #    audio_buffer = BytesIO()
    #    torchaudio.save(audio_buffer, audio.cpu(), sample_rate=22050, format="wav")
    #    audio_buffer.seek(0)

  #  except Exception as e:
  #      print(f"An error occurred during speech synthesis: {e}")
