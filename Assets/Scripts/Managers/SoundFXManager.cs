using UnityEngine;

public class SoundFXManager : MonoBehaviour
{
    public static SoundFXManager Instance;
    public AudioSource soundFXObject;


    private void Awake()
    {
        if (Instance == null) Instance = this;
    }

    public void PlaySoundFX(AudioClip clip, Transform sourceTransform, float volume = 1f, float length = 0f)
    {
        AudioSource audioSource = Instantiate(this.soundFXObject, sourceTransform.position, Quaternion.identity);
        audioSource.clip = clip;
        audioSource.volume = volume;
        audioSource.Play();
        float clipLength = length <= 0f && audioSource.clip 
            ? audioSource.clip.length
            : length;
        Destroy(audioSource.gameObject, clipLength);
    }
}