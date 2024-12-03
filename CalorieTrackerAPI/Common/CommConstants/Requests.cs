using Common.Entities;

namespace Common.CommConstants
{
    #region Base Requests
    public abstract class DataRequest : IRequest
    {
        public bool ContainsData
        {
            get { return true; }
        }
    }

    public abstract class NoDataRequest : IRequest
    {
        public bool ContainsData
        {
            get { return false; }
        }
    }
    #endregion

    #region Meal Requests
    public class CreateMealRequest : DataRequest
    {
        public CreateMealRequest(string title, double calories, double carbs, double protein, double fat)
            : base()
        {
            Title = title;
            Calories = calories;
            Carbs = carbs;
            Protein = protein;
            Fat = fat;
        }
        public string Title { get; set; }
        public double Calories { get; set; }
        public double Carbs { get; set; }
        public double Protein { get; set; }
        public double Fat { get; set; }
    }

    public class UpdateMealRequest : DataRequest
    {
        public UpdateMealRequest(int id, string title, double calories, double carbs, double protein, double fat)
            : base()
        {
            Id = id;
            Title = title;
            Calories = calories;
            Carbs = carbs;
            Protein = protein;
            Fat = fat;
        }

        public int Id { get; set; }
        public string Title { get; set; }
        public double Calories { get; set; }
        public double Carbs { get; set; }
        public double Protein { get; set; }
        public double Fat { get; set; }
    }
    #endregion
}
