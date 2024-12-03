namespace Common.Entities
{
    public class Meal : BaseEntity
    {
        public Meal(string title, double calories, double carbs, double protein, double fat)
        {
            Title = title;
            Calories = calories;
            Carbs = carbs;
            Protein = protein;
            Fat = fat;
        }

        public Meal()
        {

        }

        public string Title { get; set; }
        public double Calories { get; set; }
        public double Carbs { get; set; }
        public double Protein { get; set; }
        public double Fat { get; set; }
    }
}
