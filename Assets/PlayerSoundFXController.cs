
using System.Collections.Generic;
using UnityEngine;

public enum SoundFXType
{
    Attack,
    TakeDamage,
    Die,
    Walk,
    Dash
}
public class PlayerSoundFXController : MonoBehaviour
{
    [SerializeField] private List<AudioClip> attackSFX, takeDamageSFX, dieSFX, walkSFX, dashSFX;
    public void PlaySoundFX(SoundFXType soundFXType)
    {
        switch (soundFXType)
        {
            case SoundFXType.Attack:
                if (attackSFX.Count > 0) 
                    SoundFXManager.Instance.PlaySoundFX(attackSFX[Random.Range(0, attackSFX.Count)], transform);
                break;
            case SoundFXType.TakeDamage:
                if (takeDamageSFX.Count > 0)
                    SoundFXManager.Instance.PlaySoundFX(takeDamageSFX[Random.Range(0, takeDamageSFX.Count)], transform);
                break;
            case SoundFXType.Die:
                if (dieSFX.Count > 0)
                    SoundFXManager.Instance.PlaySoundFX(dieSFX[Random.Range(0, dieSFX.Count)], transform);
                break;
            case SoundFXType.Walk:
                if (walkSFX.Count > 0)
                    SoundFXManager.Instance.PlaySoundFX(walkSFX[Random.Range(0, walkSFX.Count)], transform);
                break;
            case SoundFXType.Dash:
                if (dashSFX.Count > 0)
                    SoundFXManager.Instance.PlaySoundFX(dashSFX[Random.Range(0, dashSFX.Count)], transform, 0.3f);
                break;
        }
    }
}
