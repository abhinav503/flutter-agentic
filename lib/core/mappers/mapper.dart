abstract interface class Mapper<Model, Entity> {
  Entity toEntity(Model model);
  Model toModel(Entity entity);
}
