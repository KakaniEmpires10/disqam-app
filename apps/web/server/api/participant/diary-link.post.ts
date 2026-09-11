import { createDiaryLink } from '../../services/diary-access'

export default adminEndpoint(async (event) => {
  const participant = await requireParticipant(event)
  return createDiaryLink(participant.id)
})
